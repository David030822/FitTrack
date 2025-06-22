using dotnet.DAL;
using dotnet.DTOs;
using dotnet.Services;
using Microsoft.AspNetCore.Mvc;

namespace dotnet.Controllers
{
    [ApiController]
    [Route("schedules/meals")]
    public class MealScheduleController : ControllerBase
    {
        private readonly IMealScheduleService _service;

        public MealScheduleController(IMealScheduleService service)
        {
            _service = service;
        }

        [HttpGet("user/{userId}")]
        public async Task<ActionResult<List<MealScheduleDto>>> GetSchedules(int userId)
        {
            var schedules = await _service.GetSchedulesForUserAsync(userId);
            return Ok(schedules.Select(MapToDto).ToList());
        }

        [HttpGet("{scheduleId}")]
        public async Task<ActionResult<MealScheduleDto>> GetSchedule(int scheduleId)
        {
            var schedule = await _service.GetScheduleByIdAsync(scheduleId);
            if (schedule == null) return NotFound();

            return Ok(MapToDto(schedule));
        }

        [HttpPost("user/{userId}")]
        public async Task<ActionResult<MealScheduleDto>> CreateSchedule(int userId, [FromBody] UpdateScheduleTitleDto dto)
        {
            var schedule = await _service.CreateScheduleAsync(userId, dto.Title);
            return Ok(MapToDto(schedule));
        }

        [HttpPut("{scheduleId}/title")]
        public async Task<IActionResult> UpdateScheduleTitle(int scheduleId, [FromBody] UpdateScheduleTitleDto dto)
        {
            if (string.IsNullOrWhiteSpace(dto.Title))
                return BadRequest("Title is required");

            await _service.UpdateScheduleTitleAsync(scheduleId, dto.Title);
            return NoContent();
        }

        [HttpDelete("{scheduleId}")]
        public async Task<IActionResult> DeleteSchedule(int scheduleId)
        {
            await _service.DeleteScheduleAsync(scheduleId);
            return NoContent();
        }

        [HttpGet("day/{dayId}")]
        public async Task<ActionResult<MealScheduleDayDto>> GetDay(int dayId)
        {
            var day = await _service.GetDayAsync(dayId);
            return Ok(MapToDto(day));
        }

        [HttpGet("day/{dayId}/meals")]
        public async Task<ActionResult<List<PlannedMealDto>>> GetMealsForDay(int dayId)
        {
            var meals = await _service.GetMealsForDayAsync(dayId);
            return Ok(meals.Select(MapToDto).ToList());
        }

        [HttpPost("day/{dayId}")]
        public async Task<ActionResult<PlannedMealDto>> AddMeal(int dayId, CreateMealRequestDto dto)
        {
            var meal = new PlannedMealDAL
            {
                MealType = dto.MealType,
                Name = dto.Name,
                Description = dto.Description,
                Calories = dto.Calories,
                Time = dto.Time
            };
            var added = await _service.AddMealToDayAsync(dayId, meal);
            return Ok(MapToDto(added));
        }

        [HttpPut("edit/{mealId}")]
        public async Task<IActionResult> UpdateMeal(int mealId, CreateMealRequestDto dto)
        {
            var meal = new PlannedMealDAL
            {
                PlannedMealID = mealId,
                MealScheduleDayID = dto.MealScheduleDayID,
                MealType = dto.MealType,
                Name = dto.Name,
                Description = dto.Description,
                Calories = dto.Calories,
                Time = dto.Time
            };
            await _service.UpdateMealAsync(meal);
            return NoContent();
        }

        [HttpDelete("delete/{mealId}")]
        public async Task<IActionResult> DeleteMeal(int mealId)
        {
            await _service.DeleteMealAsync(mealId);
            return NoContent();
        }

        [HttpPut("set-active/{scheduleId}")]
        public async Task<IActionResult> SetActiveSchedule(int scheduleId)
        {
            await _service.SetActiveScheduleAsync(scheduleId);
            return NoContent();
        }

        [HttpPut("day/{dayId}/toggle-cheat")]
        public async Task<IActionResult> ToggleCheatDay(int dayId)
        {
            await _service.ToggleCheatDayAsync(dayId);
            return NoContent();
        }

        [HttpPost("log/{mealId}")]
        public async Task<IActionResult> LogMeal(int mealId, [FromBody] MealLogRequestDto dto)
        {
            await _service.LogMealAsync(mealId, dto.Status);
            return Ok();
        }

        [HttpGet("logs/week/{userId}")]
        public async Task<ActionResult<List<MealLog>>> GetWeeklyLogs(int userId)
        {
            var logs = await _service.GetWeeklyLogsAsync(userId);
            return Ok(logs);
        }

        // 🔄 Mapping helpers

        private MealScheduleDto MapToDto(MealScheduleDAL dal) => new()
        {
            MealScheduleID = dal.MealScheduleID,
            UserID = dal.UserID,
            Title = dal.Title,
            CreatedAt = dal.CreatedAt,
            IsActive = dal.IsActive,
            Days = dal.Days?.Select(d => new MealScheduleDayDto
            {
                MealScheduleDayID = d.MealScheduleDayID,
                DayOfWeek = d.DayOfWeek,
                IsCheatDay = d.IsCheatDay,
                PlannedMeals = d.PlannedMeals?.Select(MapToDto).ToList() ?? new()
            }).ToList() ?? new()
        };

        private MealScheduleDayDto MapToDto(MealScheduleDayDAL dal) => new()
        {
            MealScheduleDayID = dal.MealScheduleDayID,
            DayOfWeek = dal.DayOfWeek,
            IsCheatDay = dal.IsCheatDay,
            PlannedMeals = dal.PlannedMeals?.Select(MapToDto).ToList() ?? new()
        };

        private PlannedMealDto MapToDto(PlannedMealDAL dal) => new()
        {
            PlannedMealID = dal.PlannedMealID,
            Name = dal.Name,
            Description = dal.Description,
            Calories = dal.Calories,
            MealType = dal.MealType,
            Time = dal.Time
        };
    }
}
