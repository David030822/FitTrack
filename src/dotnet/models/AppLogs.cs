namespace dotnet.Models
{
    public class AppLogs
    {
        public int Id { get; set; }
        public DateTime Date { get; set; }
        public string File { get; set; }
        public string Request { get; set; }
    }
}