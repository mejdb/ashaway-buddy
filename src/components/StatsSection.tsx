import { Card, CardContent } from "@/components/ui/card";

const stats = [
  {
    number: "85%",
    label: "Success Rate",
    description: "Users who quit smoking within 90 days"
  },
  {
    number: "24/7",
    label: "AI Support",
    description: "Always available when cravings hit"
  },
  {
    number: "$2,400",
    label: "Average Saved",
    description: "Money saved per user in first year"
  },
  {
    number: "10,000+",
    label: "Lives Changed",
    description: "People who successfully quit with AshAway"
  }
];

export const StatsSection = () => {
  return (
    <section className="py-20 px-6 bg-gradient-to-br from-charcoal-deep to-background">
      <div className="max-w-6xl mx-auto">
        <div className="text-center mb-16">
          <h2 className="text-4xl md:text-5xl font-bold mb-6 text-foreground">
            Proven Results
          </h2>
          <p className="text-lg text-muted-foreground max-w-2xl mx-auto">
            Join thousands who have successfully quit smoking with AshAway's evidence-based approach.
          </p>
        </div>

        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
          {stats.map((stat, index) => (
            <Card key={index} className="text-center border-charcoal-light bg-card/30 backdrop-blur">
              <CardContent className="py-8">
                <div className="text-4xl md:text-5xl font-bold mb-2 bg-gradient-to-r from-ember-glow to-primary bg-clip-text text-transparent">
                  {stat.number}
                </div>
                <h3 className="text-xl font-semibold mb-2 text-foreground">{stat.label}</h3>
                <p className="text-muted-foreground text-sm">{stat.description}</p>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    </section>
  );
};