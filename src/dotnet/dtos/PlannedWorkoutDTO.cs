namespace dotnet.DTOs
{
    public class PlannedWorkoutDto
    {
        public int PlannedWorkoutID { get; set; }
        public string Name { get; set; }
        public string? Description { get; set; }
        public string TargetMuscle { get; set; }
        public int Sets { get; set; }
        public int Reps { get; set; } 
    }
}