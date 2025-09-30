public class MessageDto
{
    public Guid Id { get; set; }
    public Guid ConversationId { get; set; }
    public string Sender { get; set; }
    public string Content { get; set; }
    public DateTime CreatedAt { get; set; }
}
