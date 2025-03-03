namespace dotnet.Models
{
    public class Meal
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public User User { get; set; }
        public int CaloriesID { get; set; }
        public Calories Calories { get; set; }
        public string Name { get; set; }
    }
}