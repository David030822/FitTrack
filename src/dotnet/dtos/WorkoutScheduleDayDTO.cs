namespace dotnet.DTOs
{
    public class WorkoutScheduleDayDto
    {
        public int WorkoutScheduleDayID { get; set; }
        public int DayOfWeek { get; set; }
        public bool IsRestDay { get; set; }
        public string? WorkoutLabel { get; set; }
        public TimeOnly? StartTime { get; set; }
        public List<PlannedWorkoutDto> PlannedWorkouts { get; set; } = new();
    }
}