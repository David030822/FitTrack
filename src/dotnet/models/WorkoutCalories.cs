namespace dotnet.Models
{
    public class WorkoutCalories
    {
        public int WorkoutId { get; set; }
        public Workout Workout { get; set; }
        public int CaloriesId { get; set; }
        public Calories Calories { get; set; }
    }
}