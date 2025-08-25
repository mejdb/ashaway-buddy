-- Fix security issues by updating functions with proper search_path

-- Update the update_updated_at_column function
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;

-- Update the handle_new_user function  
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
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
$$;