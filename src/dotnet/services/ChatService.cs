using dotnet.Data;
using dotnet.Models;
using Microsoft.EntityFrameworkCore;

namespace dotnet.Services
{
    public class ChatService
    {
        private readonly AppDbContext _context;
        private readonly AIAssistantService _aiService;

        public ChatService(AppDbContext context, AIAssistantService aiService)
        {
            _context = context;
            _aiService = aiService;
        }

        public async Task<ConversationDto> GetConversationAsync(int userId, Guid conversationId)
        {
            var conversation = await _context.Conversations
                .Include(c => c.Messages.OrderBy(m => m.CreatedAt))
                .FirstOrDefaultAsync(c => c.Id == conversationId && c.UserId == userId);

            if (conversation == null) return null;

            return new ConversationDto
            {
                Id = conversation.Id,
                Title = string.IsNullOrWhiteSpace(conversation.Title)
                    ? "Untitled Conversation"
                    : conversation.Title,
                CreatedAt = conversation.CreatedAt,
                LastUpdated = conversation.LastUpdated,
                Messages = conversation.Messages.Select(m => new MessageDto
                {
                    Id = m.Id,
                    Sender = m.Sender,
                    Content = m.Content,
                    CreatedAt = m.CreatedAt
                }).ToList()
            };
        }

        public async Task<List<ConversationDto>> GetAllConversationsAsync(int userId)
        {
            return await _context.Conversations
                .Where(c => c.UserId == userId)
                .OrderByDescending(c => c.LastUpdated)
                .Select(c => new ConversationDto
                {
                    Id = c.Id,
                    Title = string.IsNullOrWhiteSpace(c.Title)
                        ? "Untitled Conversation"
                        : c.Title,
                    CreatedAt = c.CreatedAt,
                    LastUpdated = c.LastUpdated
                })
                .ToListAsync();
        }

        public async Task<ConversationDto> SendMessageAsync(int userId, Guid conversationId, string userMessage)
        {
            if (string.IsNullOrWhiteSpace(userMessage))
            {
                throw new Exception("Message cannot be empty");
            }

            Conversation conversation;

            if (conversationId == Guid.Empty)
            {
                // Create new conversation
                var systemPrompt = _aiService.GetSystemPrompt();

                conversation = new Conversation
                {
                    Id = Guid.NewGuid(),
                    UserId = userId,
                    Title = "New Conversation",
                    CreatedAt = DateTime.UtcNow,
                    LastUpdated = DateTime.UtcNow,
                    SystemContext = systemPrompt,
                    Messages = new List<Message>()
                };

                _context.Conversations.Add(conversation);
                await _context.SaveChangesAsync(); // Save now so we can use the new ID
            }
            else
            {
                // Load existing conversation
                conversation = await _context.Conversations
                    .Include(c => c.Messages.OrderBy(m => m.CreatedAt))
                    .FirstOrDefaultAsync(c => c.Id == conversationId && c.UserId == userId);

                if (conversation == null)
                {
                    throw new Exception("Conversation not found or unauthorized");
                }
            }

            var messages = conversation.Messages.OrderBy(m => m.CreatedAt).ToList();

            // Add user message
            var userMsg = new Message
            {
                Id = Guid.NewGuid(),
                ConversationId = conversation.Id,
                Sender = "user",
                Content = userMessage,
                CreatedAt = DateTime.UtcNow
            };
            _context.Messages.Add(userMsg);
            await _context.SaveChangesAsync();

            // Build context: first system prompt if new, then last 5 msg pairs
            var context = new List<(string Role, string Content)>();

            if (!string.IsNullOrWhiteSpace(conversation.SystemContext))
            {
                context.Add(("system", conversation.SystemContext));
            }

            var recentMessages = messages
                .TakeLast(5)
                .Select(m => (m.Sender, m.Content));

            context.AddRange(recentMessages);

            context.Add(("user", userMessage)); // Add latest user message

            // Get AI response
            var aiReply = await _aiService.GetAIReplyAsync(context);

            var assistantMsg = new Message
            {
                Id = Guid.NewGuid(),
                ConversationId = conversation.Id,
                Sender = "assistant",
                Content = aiReply,
                CreatedAt = DateTime.UtcNow
            };
            _context.Messages.Add(assistantMsg);

            conversation.LastUpdated = DateTime.UtcNow;
            // conversation.Title = userMsg.Content.Length > 30 ? userMsg.Content.Substring(0, 20) + "..." : userMsg.Content;

            await _context.SaveChangesAsync();

            if (string.IsNullOrWhiteSpace(conversation.Title) || conversation.Title.StartsWith("New Conversation"))
            {
                var titleContext = context.TakeLast(10).ToList(); // use recent context
                var title = await _aiService.GenerateConversationTitleAsync(titleContext);
                conversation.Title = title;
                await _context.SaveChangesAsync();
            }

            // Reload messages to include new ones
            var updatedMessages = await _context.Messages
                .Where(m => m.ConversationId == conversation.Id)
                .OrderBy(m => m.CreatedAt)
                .ToListAsync();

            return new ConversationDto
            {
                Id = conversation.Id,
                Title = conversation.Title,
                CreatedAt = conversation.CreatedAt,
                LastUpdated = conversation.LastUpdated,
                Messages = updatedMessages.Select(m => new MessageDto
                {
                    Id = m.Id,
                    ConversationId = m.ConversationId,
                    Sender = m.Sender,
                    Content = m.Content,
                    CreatedAt = m.CreatedAt
                }).ToList()
            };
        }

        public async Task<bool> UpdateConversationTitleAsync(int userId, Guid conversationId, string newTitle)
        {
            var convo = await _context.Conversations
                .FirstOrDefaultAsync(c => c.Id == conversationId && c.UserId == userId);

            if (convo == null) return false;

            convo.Title = newTitle;
            convo.LastUpdated = DateTime.UtcNow;
            await _context.SaveChangesAsync();

            return true;
        }

        public async Task<bool> DeleteConversationAsync(int userId, Guid conversationId)
        {
            var convo = await _context.Conversations
                .Include(c => c.Messages)
                .FirstOrDefaultAsync(c => c.Id == conversationId && c.UserId == userId);

            if (convo == null) return false;

            _context.Messages.RemoveRange(convo.Messages);
            _context.Conversations.Remove(convo);
            await _context.SaveChangesAsync();

            return true;
        }

        public async Task<UserAdviceDTO> GetPersonalizedAdviceAsync(int userId, string userInput)
        {
            var user = await _context.Users.FindAsync(userId);

            if (user == null)
                throw new Exception("User not found");

            // Build prompt
            var systemPrompt = _aiService.GetSystemPrompt();

            var userPrompt = string.IsNullOrWhiteSpace(userInput) ? "" : userInput + "\n\n";

            userPrompt += $@"
            Here is my profile:
            - Age: {user.Age}
            - Gender: {user.Gender}
            - Height: {user.Height} cm
            - Weight: {user.Weight} kg
            - Body Fat: {user.BodyFat} %
            - Fitness Goal: {user.Goal}

            Based on this data, tell me how do my numbers compare to each other and my goal.
            Give me some tailored advice on how to use the FitTrack app effectively to reach my goal.
            Keep it friendly and specific. Provide numbers and example training and meals too.
            End with an estimate of how much time it will take to reach my goal.";

            var context = new List<(string Role, string Content)>
            {
                ("system", systemPrompt),
                ("user", userPrompt)
            };

            // Get AI reply
            var aiReply = await _aiService.GetAIReplyAsync(context);

            context.Add(("assistant", aiReply));
            var title = await _aiService.GenerateConversationTitleAsync(context);

            // Save advice
            var advice = new UserAdvice
            {
                Id = Guid.NewGuid(),
                UserId = userId,
                Prompt = userInput,
                Advice = aiReply,
                Title = title,
                CreatedAt = DateTime.UtcNow
            };

            _context.UserAdvices.Add(advice);
            await _context.SaveChangesAsync();

            // Return DTO
            return new UserAdviceDTO
            {
                Id = advice.Id,
                Advice = aiReply,
                Title = title,
                CreatedAt = advice.CreatedAt
            };
        }

        public async Task<UserAdviceDTO?> GetAdviceAsync(int userId, Guid adviceId)
        {
            var advice = await _context.UserAdvices
                .FirstOrDefaultAsync(a => a.Id == adviceId && a.UserId == userId);

            if (advice == null) return null;

            return new UserAdviceDTO
            {
                Id = advice.Id,
                Title = advice.Title,
                Advice = advice.Advice,
                CreatedAt = advice.CreatedAt
            };
        }

        public async Task<List<UserAdviceDTO>> GetAllAdvicesAsync(int userId)
        {
            return await _context.UserAdvices
                .Where(a => a.UserId == userId)
                .OrderByDescending(a => a.CreatedAt)
                .Select(a => new UserAdviceDTO
                {
                    Id = a.Id,
                    Title = a.Title,
                    Advice = a.Advice,
                    CreatedAt = a.CreatedAt
                })
                .ToListAsync();
        }

        public async Task<bool> UpdateAdviceTitleAsync(int userId, Guid adviceId, string newTitle)
        {
            var advice = await _context.UserAdvices
                .FirstOrDefaultAsync(a => a.Id == adviceId && a.UserId == userId);

            if (advice == null) return false;

            advice.Title = newTitle;
            await _context.SaveChangesAsync();

            return true;
        }

        public async Task<bool> DeleteAdviceAsync(int userId, Guid adviceId)
        {
            var advice = await _context.UserAdvices
                .FirstOrDefaultAsync(a => a.Id == adviceId && a.UserId == userId);

            if (advice == null) return false;

            _context.UserAdvices.Remove(advice);
            await _context.SaveChangesAsync();

            return true;
        }
    }
}