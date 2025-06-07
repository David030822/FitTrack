public class ChatRequest
{
    public int UserId { get; set; }
    public Guid ConversationId { get; set; }
    public string Message { get; set; } = string.Empty;
}