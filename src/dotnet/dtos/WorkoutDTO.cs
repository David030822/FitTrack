namespace dotnet.DTOs;

public class WorkoutDTO
{
    public int Id { get; set; }
    public double? Calories { get; set; }
    public string? Category { get; set; }
    public double? Distance { get; set; }
    public DateTime? StartDate { get; set; }
    public DateTime? EndDate { get; set; }
    // Derived fields
    public string? Duration { get; set; }
    public string? AvgPace { get; set; }
    public string? Description { get; set; }
}