import { Button } from "@/components/ui/button";
import heroImage from "@/assets/hero-ashaway.jpg";

export const HeroSection = () => {
  return (
    <section className="relative min-h-screen flex items-center justify-center overflow-hidden">
      {/* Background Image */}
      <div 
        className="absolute inset-0 bg-cover bg-center bg-no-repeat"
        style={{ backgroundImage: `url(${heroImage})` }}
      >
        <div className="absolute inset-0 bg-gradient-to-br from-charcoal-deep/90 to-background/70" />
      </div>

      {/* Content */}
      <div className="relative z-10 text-center px-6 max-w-4xl mx-auto">
        <h1 className="text-5xl md:text-7xl font-bold mb-6 bg-gradient-to-r from-foreground to-ember-glow bg-clip-text text-transparent">
          AshAway
        </h1>
        <p className="text-xl md:text-2xl mb-4 text-muted-foreground">
          Your AI-powered journey to quit smoking
        </p>
        <p className="text-lg mb-8 text-muted-foreground max-w-2xl mx-auto">
          Personalized support, real-time coaching, and proven techniques to help you break free from cigarettes forever.
        </p>
        
        <div className="flex flex-col sm:flex-row gap-4 justify-center">
          <Button variant="ember" size="lg" className="text-lg px-8 py-6">
            Start Your Journey
          </Button>
          <Button variant="outline" size="lg" className="text-lg px-8 py-6">
            Learn More
          </Button>
        </div>
      </div>

      {/* Floating particles effect */}
      <div className="absolute inset-0 pointer-events-none">
        <div className="absolute top-1/4 left-1/4 w-2 h-2 bg-ember-glow/30 rounded-full animate-pulse" />
        <div className="absolute top-3/4 right-1/3 w-1 h-1 bg-mint-success/40 rounded-full animate-pulse delay-1000" />
        <div className="absolute bottom-1/4 left-1/3 w-1.5 h-1.5 bg-ember-glow/20 rounded-full animate-pulse delay-500" />
      </div>
    </section>
  );
};