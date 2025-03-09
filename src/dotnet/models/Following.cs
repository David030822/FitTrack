namespace dotnet.Models
{
    public class Following
    {
        public int Id { get; set; }
        public int FollowerId { get; set; }
        public int FollowedId { get; set; }
    }
}