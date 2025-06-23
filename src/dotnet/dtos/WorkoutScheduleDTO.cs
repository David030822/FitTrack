namespace dotnet.DTOs
{
    public class WorkoutScheduleDto
    {
        public int WorkoutScheduleID { get; set; }
        public int UserID { get; set; }
        public DateTime CreatedAt { get; set; }
        public bool IsActive { get; set; }
        public string? Title { get; set; }
        public List<WorkoutScheduleDayDto> Days { get; set; } = new();
    }
}