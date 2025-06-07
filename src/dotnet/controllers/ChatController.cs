using dotnet.Services;
using Microsoft.AspNetCore.Mvc;

namespace dotnet.Controllers
{
    [ApiController]
    [Route("chat")]
    public class ChatController : ControllerBase
    {
        private readonly ChatService _chatService;

        public ChatController(ChatService chatService)
        {
            _chatService = chatService;
        }

        [HttpGet("{userId}/conversations/{conversationId}")]
        public async Task<IActionResult> GetConversation(Guid conversationId, int userId)
        {
            var convo = await _chatService.GetConversationAsync(userId, conversationId);
            return convo != null ? Ok(convo) : NotFound();
        }

        [HttpGet("{userId}/conversations")]
        public async Task<IActionResult> GetAllConversations(int userId)
        {
            var conversations = await _chatService.GetAllConversationsAsync(userId);
            return Ok(conversations);
        }

        [HttpPost("send")]
        public async Task<IActionResult> Send([FromBody] ChatRequest request)
        {
            try
            {
                var messages = await _chatService.SendMessageAsync(request.UserId, request.ConversationId, request.Message);
                return Ok(messages);
            }
            catch (Exception ex)
            {
                return BadRequest(new { error = ex.Message });
            }
        }

        [HttpPut("{userId}/conversations/{conversationId}/title")]
        public async Task<IActionResult> UpdateTitle(int userId, Guid conversationId, [FromBody] UpdateTitleRequest request)
        {
            var success = await _chatService.UpdateConversationTitleAsync(userId, conversationId, request.NewTitle);
            return success ? Ok() : NotFound();
        }

        [HttpDelete("{userId}/conversations/{conversationId}/delete")]
        public async Task<IActionResult> DeleteConversation(int userId, Guid conversationId)
        {
            var success = await _chatService.DeleteConversationAsync(userId, conversationId);
            return success ? Ok() : NotFound();
        }
    }
}