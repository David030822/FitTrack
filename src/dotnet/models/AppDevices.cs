namespace dotnet.Models
{
    public class AppDevices
    {
        public int Id { get; set; }
        public DateTime Registered { get; set; }
        public double Used { get; set; }
        public DateTime LastUsed { get; set; }
    }
}