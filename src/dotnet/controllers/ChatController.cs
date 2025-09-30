using dotnet.DTOs;
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

        // POST: api/PersonalizedMealPlan/personal-meal-plan
        [HttpPost("personal-meal-plan")]
        public async Task<IActionResult> GetPersonalizedMealPlan([FromBody] MealPlanRequestDTO mealPlanRequest)
        {
            var plan = await _chatService.GetPersonalizedMealPlanAsync(mealPlanRequest);
            return Ok(plan);
        }

        // GET: api/PersonalizedMealPlan/{userId}/mealplans
        [HttpGet("{userId}/mealplans")]
        public async Task<ActionResult<List<UserMealPlanDTO>>> GetAllUserMealPlans(int userId)
        {
            var mealPlans = await _chatService.GetAllMealPlansAsync(userId);
            return Ok(mealPlans);
        }

        // GET: api/PersonalizedMealPlan/{userId}/mealplan/{mealPlanId}
        [HttpGet("{userId}/mealplan/{mealPlanId}")]
        public async Task<ActionResult<UserMealPlanDTO>> GetMealPlanById(int userId, Guid mealPlanId)
        {
            var mealPlan = await _chatService.GetMealPlanAsync(userId, mealPlanId);
            if (mealPlan == null)
                return NotFound();

            return Ok(mealPlan);
        }

        // PUT: api/PersonalizedMealPlan/{userId}/mealplans/{mealPlanId}/title
        [HttpPut("{userId}/mealplans/{mealPlanId}/title")]
        public async Task<IActionResult> UpdateMealPlanTitle(int userId, Guid mealPlanId, [FromBody] UpdateTitleRequest request)
        {
            var success = await _chatService.UpdateMealPlanTitleAsync(userId, mealPlanId, request.NewTitle);
            return success ? Ok() : NotFound();
        }

        // DELETE: api/PersonalizedMealPlan/{userId}/mealplans/{mealPlanId}/delete
        [HttpDelete("{userId}/mealplans/{mealPlanId}/delete")]
        public async Task<IActionResult> DeleteMealPlan(int userId, Guid mealPlanId)
        {
            var success = await _chatService.DeleteMealPlanAsync(userId, mealPlanId);
            return success ? Ok() : NotFound();
        }

        // POST: api/PersonalizedWorkoutPlan/personal-workout-plan
        [HttpPost("personal-workout-plan")]
        public async Task<IActionResult> GetPersonalizedWorkoutPlan([FromBody] WorkoutPlanRequestDTO workoutPlanRequest)
        {
            var plan = await _chatService.GetPersonalizedWorkoutPlanAsync(workoutPlanRequest);
            return Ok(plan);
        }

        // GET: api/PersonalizedWorkoutPlan/{userId}/workoutplans
        [HttpGet("{userId}/workoutplans")]
        public async Task<ActionResult<List<UserWorkoutPlanDTO>>> GetAllUserWorkoutPlans(int userId)
        {
            var workoutPlans = await _chatService.GetAllWorkoutPlansAsync(userId);
            return Ok(workoutPlans);
        }

        // GET: api/PersonalizedWorkoutPlan/{userId}/workoutplan/{workoutPlanId}
        [HttpGet("{userId}/workoutplan/{workoutPlanId}")]
        public async Task<ActionResult<UserWorkoutPlanDTO>> GetWorkoutPlanById(int userId, Guid workoutPlanId)
        {
            var workoutPlan = await _chatService.GetWorkoutPlanAsync(userId, workoutPlanId);
            if (workoutPlan == null)
                return NotFound();

            return Ok(workoutPlan);
        }

        // PUT: api/PersonalizedWorkoutPlan/{userId}/workoutplans/{workoutPlanId}/title
        [HttpPut("{userId}/workoutplans/{workoutPlanId}/title")]
        public async Task<IActionResult> UpdateWorkoutPlanTitle(int userId, Guid workoutPlanId, [FromBody] UpdateTitleRequest request)
        {
            var success = await _chatService.UpdateWorkoutPlanTitleAsync(userId, workoutPlanId, request.NewTitle);
            return success ? Ok() : NotFound();
        }

        // DELETE: api/PersonalizedWorkoutPlan/{userId}/workoutplans/{workoutPlanId}/delete
        [HttpDelete("{userId}/workoutplans/{workoutPlanId}/delete")]
        public async Task<IActionResult> DeleteWorkoutPlan(int userId, Guid workoutPlanId)
        {
            var success = await _chatService.DeleteWorkoutPlanAsync(userId, workoutPlanId);
            return success ? Ok() : NotFound();
        }
    }
}