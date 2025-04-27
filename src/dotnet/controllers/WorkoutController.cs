using dotnet.DTOs;
using dotnet.Helper;
using dotnet.Models;
using dotnet.Services;
using Microsoft.AspNetCore.Mvc;

namespace dotnet.Controllers
{
    [Route("api/workouts")]
    [ApiController]
    public class WorkoutController : ControllerBase
    {
        private readonly IWorkoutService _workoutService;
        private readonly ICategoryService _categoryService;

        public WorkoutController(IWorkoutService workoutService, ICategoryService categoryService)
        {
            _workoutService = workoutService;
            _categoryService = categoryService;
        }

        [HttpGet("all")]
        public async Task<IActionResult> GetAllWorkouts()
        {
            var workouts = await _workoutService.GetAllWorkoutsAsync();
            return Ok(workouts.Select(WorkoutConverter.FromWorkoutToWorkoutDTO));
        }

        [HttpGet("get/{id}")]
        public async Task<IActionResult> GetWorkoutById(int id)
        {
            var workout = await _workoutService.GetWorkoutByIdAsync(id);
            if (workout == null)
                return NotFound();

            return Ok(WorkoutConverter.FromWorkoutToWorkoutDTO(workout));
        }

        [HttpGet("user/{userId}")]
        public async Task<IActionResult> GetWorkoutsByUserId(int userId)
        {
            var workouts = await _workoutService.GetWorkoutDTOsForUserAsync(userId);
            foreach (var w in workouts) {
                Console.WriteLine($"👉Controller WorkoutID: {w.Id}, Category: {(w.Category == null ? "NULL" : w.Category)}, Calories: {(w.Calories == null ? "NULL" : w.Calories.ToString())}, Date: {w.StartDate} - {w.EndDate}");
            }
            return Ok(workouts);
        }

        [HttpPost("create")]
        public async Task<IActionResult> AddWorkout([FromBody] WorkoutDTO workoutDTO, int userId, int categoryId)
        {
            // var ongoingWorkout = await _workoutService.GetOngoingWorkoutForUser(userId);
            // if (ongoingWorkout != null)
            // {
            //     return BadRequest(new { error = "❌You already have an active workout." });
            // }

            var workout = WorkoutConverter.FromWorkoutDTOToWorkout(workoutDTO, userId, categoryId);
            var savedWorkout = await _workoutService.AddWorkoutAsync(workout);

            var category = await _categoryService.GetCategoryByIdAsync(categoryId);
            if (category == null)
                return NotFound();

            var savedWorkoutDto = new WorkoutDTO
            {
                Id = savedWorkout.Id,
                Distance = savedWorkout.Distance,
                StartDate = savedWorkout.StartDate,
                EndDate = savedWorkout.EndDate,
                Category = category.Name
            };
            Console.WriteLine("savedWorkout.Id: " + savedWorkout.Id);
            return CreatedAtAction(nameof(GetWorkoutById), new { id = savedWorkout.Id }, savedWorkoutDto);
        }
        // http://localhost:5082/api/workouts?userId=41&categoryId=3

        [HttpPut("update/{id}")]
        public async Task<IActionResult> UpdateWorkout(int id, [FromBody] WorkoutDTO workoutDTO)
        {
            var existingWorkout = await _workoutService.GetWorkoutByIdAsync(id);
            if (existingWorkout == null)
                return NotFound();

            existingWorkout.Distance = workoutDTO.Distance ?? existingWorkout.Distance;

            await _workoutService.UpdateWorkoutAsync(existingWorkout);
            return NoContent();
        }

        [HttpDelete("delete/{id}")]
        public async Task<IActionResult> DeleteWorkout(int id)
        {
            var workout = await _workoutService.GetWorkoutByIdAsync(id);
            if (workout == null)
                return NotFound();

            await _workoutService.DeleteWorkoutAsync(id);
            return NoContent();
        }

        [HttpPut("{workoutId}/update-calories")]
        public async Task<IActionResult> UpdateWorkoutCalories(int workoutId, [FromBody] UpdateWorkoutDTO updateWorkoutDto)
        {
            Console.WriteLine($"🟢 NewCalories: {updateWorkoutDto.NewCalories}");
            Console.WriteLine($"🟢 Distance: {updateWorkoutDto.Distance}");
            Console.WriteLine($"🟢 Duration: {updateWorkoutDto.Duration}");
            Console.WriteLine($"🟢 AvgPace: {updateWorkoutDto.AvgPace}");
            try
            {
                await _workoutService.UpdateWorkoutCaloriesAsync(workoutId, updateWorkoutDto.NewCalories, updateWorkoutDto.Distance ?? 0.0);
                return Ok(new { message = "Calories and distance updated successfully" });
            }
            catch (Exception ex)
            {
                return BadRequest(new { error = ex.Message });
            }
        }
        // http://localhost:5082/api/workouts/13/update-calories
        // {
        //     "newCalories": 500,
        //     "distance": 13.5
        // }
    }
}