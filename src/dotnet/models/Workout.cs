namespace dotnet.Models
{
    public class Workout
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public int CategoryId { get; set; }
        public double Distance { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }

        // Navigation properties
        public User User { get; set; }  // Relationship to User
        public WorkoutCategory Category { get; set; }  // Relationship to WorkoutCategory
        // Relationship to WorkoutCalories
        public WorkoutCalories WorkoutCalories { get; set; }
    }
}