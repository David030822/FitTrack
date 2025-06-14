using dotnet.Helper;
using dotnet.Models;
using dotnet.Services;
using Microsoft.AspNetCore.Mvc;

namespace dotnet.Controllers
{
    [ApiController]
    [Route("chat")]
    public class ChatController : ControllerBase
    {
        private readonly ChatService _chatService;
        private readonly UserService _userService;

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

        [HttpPost("personal-advice")]
        public async Task<IActionResult> GetPersonalAdvice([FromBody] AdviceRequest adviceRequest)
        {
            var advice = await _chatService.GetPersonalizedAdviceAsync(adviceRequest.UserId, adviceRequest.UserInput);
            return Ok(advice);
        }

        [HttpGet("{userId}/advices")]
        public async Task<ActionResult<List<UserAdviceDTO>>> GetAllUserAdvices(int userId)
        {
            var advices = await _chatService.GetAllAdvicesAsync(userId);
            return Ok(advices);
        }

        // GET: api/UserAdvice/user/5/advice/abc-123-guid
        [HttpGet("{userId}/advice/{adviceId}")]
        public async Task<ActionResult<UserAdviceDTO>> GetAdviceById(int userId, Guid adviceId)
        {
            var advice = await _chatService.GetAdviceAsync(userId, adviceId);
            if (advice == null)
                return NotFound();

            return Ok(advice);
        }

        [HttpPut("{userId}/advices/{adviceId}/title")]
        public async Task<IActionResult> UpdateAdviceTitle(int userId, Guid adviceId, [FromBody] UpdateTitleRequest request)
        {
            var success = await _chatService.UpdateAdviceTitleAsync(userId, adviceId, request.NewTitle);
            return success ? Ok() : NotFound();
        }

        [HttpDelete("{userId}/advices/{adviceId}/delete")]
        public async Task<IActionResult> DeleteAdvice(int userId, Guid adviceId)
        {
            var success = await _chatService.DeleteAdviceAsync(userId, adviceId);
            return success ? Ok() : NotFound();
        }
    }
}