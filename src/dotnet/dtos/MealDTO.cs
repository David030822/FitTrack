namespace dotnet.DTOs
{
    public class MealDTO
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string? Description { get; set; }
        public double Calories { get; set; }
        public DateTime Date { get; set; }
    }
}