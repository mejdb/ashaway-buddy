import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";

export const CTASection = () => {
  return (
    <section className="py-20 px-6">
      <div className="max-w-4xl mx-auto">
        <Card className="border-charcoal-light bg-gradient-to-br from-card to-charcoal-deep overflow-hidden relative">
          <div className="absolute inset-0 bg-gradient-to-r from-ember-glow/5 to-mint-success/5" />
          <CardContent className="relative z-10 py-16 px-8 text-center">
            <h2 className="text-4xl md:text-5xl font-bold mb-6 bg-gradient-to-r from-foreground to-ember-glow bg-clip-text text-transparent">
              Ready to Quit for Good?
            </h2>
            <p className="text-lg text-muted-foreground mb-8 max-w-2xl mx-auto">
              Join AshAway today and take the first step towards a smoke-free life. 
              Your journey to freedom starts now.
            </p>
            
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Button variant="ember" size="lg" className="text-lg px-8 py-6">
                Start Free Trial
              </Button>
              <Button variant="outline" size="lg" className="text-lg px-8 py-6">
                Download App
              </Button>
            </div>
            
            <p className="text-sm text-muted-foreground mt-6">
              No credit card required • 7-day free trial • Cancel anytime
            </p>
          </CardContent>
        </Card>
      </div>
    </section>
  );
};