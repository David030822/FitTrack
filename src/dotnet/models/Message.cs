using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace dotnet.Models
{
    public class Message
    {
        [Key]
        public Guid Id { get; set; }
        [Required]
        public Guid ConversationId { get; set; }
        [ForeignKey("ConversationId")]
        public Conversation Conversation { get; set; } = null!;
        [Required]
        public string Sender { get; set; } = "user"; // or "assistant"
        [Required]
        public string Content { get; set; } = "";
        [Required]
        public DateTime CreatedAt { get; set; }
    }
}