namespace dotnet.Models
{
    public class Meal
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public string Name { get; set; }
        public string? Description { get; set; }
        public double Calories { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}