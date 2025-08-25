import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Brain, Heart, Shield, TrendingUp } from "lucide-react";

const benefits = [
  {
    icon: Brain,
    title: "AI-Powered Coaching",
    description: "Personalized support that adapts to your unique triggers and patterns."
  },
  {
    icon: Shield,
    title: "24/7 Craving Support", 
    description: "Instant access to proven techniques when you need them most."
  },
  {
    icon: Heart,
    title: "Health Tracking",
    description: "Watch your health improve in real-time with milestone celebrations."
  },
  {
    icon: TrendingUp,
    title: "Progress Analytics",
    description: "Track streaks, money saved, and build lasting healthy habits."
  }
];

export const BenefitsSection = () => {
  return (
    <section className="py-20 px-6">
      <div className="max-w-6xl mx-auto">
        <div className="text-center mb-16">
          <h2 className="text-4xl md:text-5xl font-bold mb-6 bg-gradient-to-r from-foreground to-ember-glow bg-clip-text text-transparent">
            Why Choose AshAway?
          </h2>
          <p className="text-lg text-muted-foreground max-w-2xl mx-auto">
            Combining cutting-edge AI with proven quit-smoking methods to give you the best chance of success.
          </p>
        </div>

        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
          {benefits.map((benefit, index) => (
            <Card key={index} className="border-charcoal-light bg-card/50 backdrop-blur hover:shadow-card transition-all duration-300 hover:translate-y-[-4px]">
              <CardHeader className="text-center pb-4">
                <div className="w-16 h-16 mx-auto mb-4 rounded-full bg-gradient-to-br from-primary to-ember-glow flex items-center justify-center">
                  <benefit.icon className="w-8 h-8 text-primary-foreground" />
                </div>
                <CardTitle className="text-xl text-foreground">{benefit.title}</CardTitle>
              </CardHeader>
              <CardContent className="text-center">
                <p className="text-muted-foreground">{benefit.description}</p>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    </section>
  );
};