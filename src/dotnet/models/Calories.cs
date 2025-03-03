namespace dotnet.Models
{
    public class Calories
    {
        public int Id { get; set; }
        public double Amount { get; set; }
        public DateTime DateTime { get; set; }

        // Navigation property for many-to-many relationship
        public WorkoutCalories WorkoutCalories { get; set; }
        public Steps Steps { get; set; }
        public Meal Meal { get; set; }
    }
}