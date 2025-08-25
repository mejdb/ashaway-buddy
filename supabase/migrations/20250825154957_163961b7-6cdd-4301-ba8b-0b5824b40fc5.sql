-- Create custom types
CREATE TYPE public.app_role AS ENUM ('user', 'admin');
CREATE TYPE public.notification_window_label AS ENUM ('morning', 'midday', 'evening');
CREATE TYPE public.activity_type AS ENUM ('breathing', 'urge_surf', 'walk', 'water', 'education');
CREATE TYPE public.message_role AS ENUM ('user', 'assistant', 'system');

-- Create profiles table
CREATE TABLE public.profiles (
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  language TEXT NOT NULL DEFAULT 'en' CHECK (language IN ('en', 'fr')),
  tone TEXT NOT NULL DEFAULT 'supportive' CHECK (tone IN ('supportive', 'direct', 'casual', 'professional')),
  quit_date DATE,
  cigs_per_day INTEGER CHECK (cigs_per_day >= 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create notification_windows table
CREATE TABLE public.notification_windows (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  label public.notification_window_label NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(user_id, label)
);

-- Create checkins table
CREATE TABLE public.checkins (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  mood INTEGER NOT NULL CHECK (mood >= 1 AND mood <= 10),
  urge INTEGER NOT NULL CHECK (urge >= 0 AND urge <= 10),
  context JSONB,
  action TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create cravings table
CREATE TABLE public.cravings (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  trigger TEXT NOT NULL,
  intensity INTEGER NOT NULL CHECK (intensity >= 1 AND intensity <= 10),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create activities table
CREATE TABLE public.activities (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  type public.activity_type NOT NULL,
  duration_seconds INTEGER NOT NULL CHECK (duration_seconds >= 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create device_subscriptions table
CREATE TABLE public.device_subscriptions (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  endpoint TEXT NOT NULL,
  p256dh TEXT NOT NULL,
  auth TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(user_id, endpoint)
);

-- Create messages table (for AI coach chat)
CREATE TABLE public.messages (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role public.message_role NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create badges table
CREATE TABLE public.badges (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  key TEXT NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  awarded_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(user_id, key)
);

-- Enable RLS on all tables
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notification_windows ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.checkins ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cravings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.device_subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.badges ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for profiles
CREATE POLICY "Users can view own profile" ON public.profiles
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own profile" ON public.profiles
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own profile" ON public.profiles
  FOR UPDATE USING (auth.uid() = user_id);

-- Create RLS policies for notification_windows
CREATE POLICY "Users can manage own notification windows" ON public.notification_windows
  FOR ALL USING (auth.uid() = user_id);

-- Create RLS policies for checkins
CREATE POLICY "Users can manage own checkins" ON public.checkins
  FOR ALL USING (auth.uid() = user_id);

-- Create RLS policies for cravings
CREATE POLICY "Users can manage own cravings" ON public.cravings
  FOR ALL USING (auth.uid() = user_id);

-- Create RLS policies for activities
CREATE POLICY "Users can manage own activities" ON public.activities
  FOR ALL USING (auth.uid() = user_id);

-- Create RLS policies for device_subscriptions
CREATE POLICY "Users can manage own device subscriptions" ON public.device_subscriptions
  FOR ALL USING (auth.uid() = user_id);

-- Create RLS policies for messages
CREATE POLICY "Users can manage own messages" ON public.messages
  FOR ALL USING (auth.uid() = user_id);

-- Create RLS policies for badges
CREATE POLICY "Users can view own badges" ON public.badges
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "System can award badges" ON public.badges
  FOR INSERT WITH CHECK (true);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for profiles updated_at
CREATE TRIGGER update_profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

-- Create function to handle new user registration
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (user_id, language, tone)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'language', 'en'),
    COALESCE(NEW.raw_user_meta_data->>'tone', 'supportive')
  );
  
  -- Create default notification windows
  INSERT INTO public.notification_windows (user_id, label, start_time, end_time) VALUES
    (NEW.id, 'morning', '08:00', '10:00'),
    (NEW.id, 'midday', '12:00', '14:00'),
    (NEW.id, 'evening', '18:00', '20:00');
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger for new user registration
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- Create indexes for better performance
CREATE INDEX idx_checkins_user_created ON public.checkins(user_id, created_at DESC);
CREATE INDEX idx_cravings_user_created ON public.cravings(user_id, created_at DESC);
CREATE INDEX idx_activities_user_created ON public.activities(user_id, created_at DESC);
CREATE INDEX idx_messages_user_created ON public.messages(user_id, created_at ASC);
CREATE INDEX idx_badges_user_key ON public.badges(user_id, key);