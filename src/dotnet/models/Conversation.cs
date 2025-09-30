using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using dotnet.DAL;

namespace dotnet.Models
{
    public class Conversation
    {
        [Key]
        public Guid Id { get; set; }
        [Required]
        public int UserId { get; set; }
        [ForeignKey("UserId")]
        public UserDAL User { get; set; } = null!;
        public string? Title { get; set; }
        [Required]
        public DateTime CreatedAt { get; set; }
        [Required]
        public DateTime LastUpdated { get; set; }
        public ICollection<Message> Messages { get; set; } = new List<Message>();
        public string? SystemContext { get; set; }
    }
}