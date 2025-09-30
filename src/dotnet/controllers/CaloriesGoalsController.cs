using dotnet.DTOs;
using dotnet.Repositories;
using Microsoft.AspNetCore.Mvc;

namespace dotnet.Controllers
{
    [ApiController]
    [Route("api/calories-goals")]
    public class CaloriesGoalsController : ControllerBase
    {
        private readonly ICaloriesGoalsRepository _repo;

        public CaloriesGoalsController(ICaloriesGoalsRepository repo)
        {
            _repo = repo;
        }

        [HttpGet("all")]
        public async Task<ActionResult<IEnumerable<CaloriesGoalsDTO>>> GetAll()
        {
            return Ok(await _repo.GetAllAsync());
        }

        [HttpGet("get")]
        public async Task<ActionResult<CaloriesGoalsDTO>> Get(int userId)
        {
            var result = await _repo.GetByIdAsync(userId);
            if (result == null) return NotFound();
            return Ok(result);
        }

        [HttpPost("create")]
        public async Task<ActionResult<CaloriesGoalsDTO>> Create([FromBody] CaloriesGoalsDTO dto, int userId)
        {
            var created = await _repo.CreateAsync(dto, userId);
            return CreatedAtAction(nameof(Get), new { id = created.CaloriesGoalsID }, created);
        }

        [HttpPut("update")]
        public async Task<IActionResult> Update([FromBody] CaloriesGoalsDTO dto, int userId)
        {
            var success = await _repo.UpdateAsync(userId, dto);
            if (!success) return NotFound();
            return NoContent();
        }

        [HttpDelete("delete/{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var success = await _repo.DeleteAsync(id);
            if (!success) return NotFound();
            return NoContent();
        }

        [HttpPut("upsert")]
        public async Task<IActionResult> UpsertGoals(int userId, [FromBody] CaloriesGoalsDTO dto)
        {
            var result = await _repo.UpsertAsync(userId, dto);
            return result ? Ok() : BadRequest("Could not save goals");
        }

        // [HttpGet("total")]
        // public async Task<ActionResult<double>> GetTotalCalories(int userId, DateTime date)
        // {
        //     var total = await _repo.GetTotalCaloriesAsync(userId, date);
        //     return Ok(total);
        // }

        [HttpGet("daily-burn")]
        public async Task<ActionResult<double>> GetDailyCaloriesBurned(int userId)
        {
            var today = DateTime.UtcNow;

            var totalBurned = await _repo.GetDailyCaloriesBurnedAsync(userId, today);
            Console.WriteLine($"🟢 Total Calories Burned: {totalBurned}");

            return Ok(totalBurned);
        }

        [HttpGet("daily-intake")]
        public async Task<IActionResult> GetDailyIntake([FromQuery] int userId)
        {
            var today = DateTime.UtcNow;

            var totalIntake = await _repo.GetDailyIntakeAsync(userId, today);
            Console.WriteLine($"🟢 Total Calories Intake: {totalIntake}");

            return Ok(totalIntake);
        }

        [HttpGet("streaks")]
        public async Task<ActionResult<CaloriesGoalsDTO>> GetStreaks(int userId)
        {
            var dto = await _repo.GetStreaksAsync(userId);
            if (dto == null) return NotFound();
            return Ok(dto);
        }
    }
}
