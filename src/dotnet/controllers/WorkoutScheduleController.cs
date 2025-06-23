using dotnet.DAL;
using dotnet.DTOs;
using dotnet.Services;
using Microsoft.AspNetCore.Mvc;

namespace dotnet.Controllers
{
    [ApiController]
    [Route("schedules/workouts")]
    public class WorkoutScheduleController : ControllerBase
    {
        private readonly IWorkoutScheduleService _service;

        public WorkoutScheduleController(IWorkoutScheduleService service)
        {
            _service = service;
        }

        // === SCHEDULE ===

        [HttpPost("user/{userId}")]
        public async Task<ActionResult<WorkoutScheduleDto>> CreateSchedule(int userId, [FromBody] CreateWorkoutScheduleDto dto)
        {
            var schedule = await _service.CreateScheduleAsync(userId, dto.Title);
            return Ok(MapToDto(schedule));
        }

        [HttpGet("user/{userId}")]
        public async Task<ActionResult<List<WorkoutScheduleDto>>> GetSchedules(int userId)
        {
            var schedules = await _service.GetSchedulesForUserAsync(userId);
            return Ok(schedules.Select(MapToDto).ToList());
        }

        [HttpGet("{scheduleId}")]
        public async Task<ActionResult<WorkoutScheduleDto>> GetSchedule(int scheduleId)
        {
            var schedule = await _service.GetScheduleByIdAsync(scheduleId);
            return Ok(MapToDto(schedule));
        }

        [HttpDelete("{scheduleId}")]
        public async Task<IActionResult> DeleteSchedule(int scheduleId)
        {
            await _service.DeleteScheduleAsync(scheduleId);
            return NoContent();
        }

        [HttpPut("{scheduleId}/title")]
        public async Task<IActionResult> UpdateTitle(int scheduleId,[FromBody] UpdateWorkoutScheduleDto dto)
        {
            await _service.UpdateScheduleTitleAsync(scheduleId, dto.NewTitle);
            return NoContent();
        }

        [HttpPut("{scheduleId}/toggle-active")]
        public async Task<IActionResult> ToggleActive(int scheduleId)
        {
            await _service.ToggleActiveScheduleAsync(scheduleId);
            return NoContent();
        }

        // === DAY ===

        [HttpGet("day/{dayId}")]
        public async Task<ActionResult<WorkoutScheduleDayDto>> GetDay(int dayId)
        {
            var day = await _service.GetDayAsync(dayId);
            return Ok(MapToDto(day));
        }

        [HttpPut("day/{dayId}")]
        public async Task<IActionResult> UpdateDay(int dayId, [FromBody] UpdateWorkoutDayDto dto)
        {
            await _service.UpdateDayAsync(dayId, dto.WorkoutLabel, dto.StartTime);
            return NoContent();
        }

        [HttpPut("day/{dayId}/toggle-rest")]
        public async Task<IActionResult> ToggleRestDay(int dayId)
        {
            await _service.ToggleRestDayAsync(dayId);
            return NoContent();
        }

        // === PLANNED EXERCISE ===

        [HttpGet("day/{dayId}/workouts")]
        public async Task<ActionResult<List<PlannedWorkoutDto>>> GetWorkoutsForDay(int dayId)
        {
            var workouts = await _service.GetWorkoutsForDayAsync(dayId);
            return Ok(workouts.Select(MapToDto).ToList());
        }

        [HttpPost("day/{dayId}/exercise")]
        public async Task<ActionResult<PlannedWorkoutDto>> AddWorkout(int dayId, UpsertPlannedWorkoutDto dto)
        {
            var workout = new PlannedWorkoutDAL
            {
                Name = dto.Name,
                Description = dto.Description,
                TargetMuscle = dto.TargetMuscle,
                Sets = dto.Sets,
                Reps = dto.Reps
            };
            var ex = await _service.AddWorkoutToDayAsync(dayId, workout);
            return Ok(MapToDto(ex));
        }

        [HttpPut("exercise/{exerciseId}")]
        public async Task<IActionResult> UpdateWorkout(int exerciseId, [FromBody] UpsertPlannedWorkoutDto dto)
        {
            var existing = await _service.GetWorkoutByIdAsync(exerciseId);
            if (existing == null) return NotFound();

            existing.Name = dto.Name;
            existing.Description = dto.Description;
            existing.TargetMuscle = dto.TargetMuscle;
            existing.Sets = dto.Sets;
            existing.Reps = dto.Reps;
            existing.WorkoutScheduleDayID = dto.WorkoutScheduleDayID;

            await _service.UpdateWorkoutAsync(existing);
            return NoContent();
        }

        [HttpDelete("exercise/{exerciseId}")]
        public async Task<IActionResult> DeleteWorkout(int exerciseId)
        {
            await _service.DeleteWorkoutAsync(exerciseId);
            return NoContent();
        }

        // === MAPPERS ===

        private WorkoutScheduleDto MapToDto(WorkoutScheduleDAL dal) => new()
        {
            WorkoutScheduleID = dal.WorkoutScheduleID,
            UserID = dal.UserID,
            Title = dal.Title,
            CreatedAt = dal.CreatedAt,
            IsActive = dal.IsActive,
            Days = dal.Days?.Select(MapToDto).ToList() ?? new()
        };

        private WorkoutScheduleDayDto MapToDto(WorkoutScheduleDayDAL dal) => new()
        {
            WorkoutScheduleDayID = dal.WorkoutScheduleDayID,
            DayOfWeek = dal.DayOfWeek,
            StartTime = dal.StartTime,
            WorkoutLabel = dal.WorkoutLabel,
            IsRestDay = dal.IsRestDay,
            PlannedWorkouts = dal.PlannedWorkouts?.Select(MapToDto).ToList() ?? new()
        };

        private PlannedWorkoutDto MapToDto(PlannedWorkoutDAL dal) => new()
        {
            PlannedWorkoutID = dal.PlannedWorkoutID,
            Name = dal.Name,
            Description = dal.Description,
            TargetMuscle = dal.TargetMuscle,
            Sets = dal.Sets,
            Reps = dal.Reps
        };
    }
}