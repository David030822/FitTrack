public class ConversationDto
{
    public Guid Id { get; set; }
    public string Title { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime LastUpdated { get; set; }
    public List<MessageDto> Messages { get; set; }
}
