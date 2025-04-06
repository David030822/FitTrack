namespace dotnet.DTOs;

public class WorkoutDTO
{
    public int Id { get; set; }
    public int? Calories { get; set; }
    public String? Category { get; set; }
    public double? Distance { get; set; }
    public DateTime? StartDate { get; set; }
    public DateTime? EndDate { get; set; }
}