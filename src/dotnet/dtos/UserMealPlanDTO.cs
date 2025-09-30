namespace dotnet.DTOs;

public class UserMealPlanDTO
{
    public Guid Id { get; set; }
    public string Advice { get; set; }
    public string Title { get; set; }
    public DateTime CreatedAt { get; set; }
}
