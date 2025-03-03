namespace dotnet.Models
{
    public class WorkoutCategory
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Icon { get; set; }

        // Navigation property (optional)
        public ICollection<Workout> Workouts { get; set; }
    }
}