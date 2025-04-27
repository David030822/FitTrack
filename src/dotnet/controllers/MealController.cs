using dotnet.Converters;
using dotnet.DTOs;
using dotnet.Models;
using dotnet.Services;
using Microsoft.AspNetCore.Mvc;

namespace dotnet.Controllers
{
    [ApiController]
    [Route("api/meals")]
    public class MealController : ControllerBase
    {
        private readonly IMealService _service;

        public MealController(IMealService service)
        {
            _service = service;
        }

        [HttpGet("all")]
        public async Task<ActionResult<List<MealDTO>>> GetAllMeals()
        {
            var meals = await _service.GetAllMealsAsync();
            var mealsDto = meals.Select(MealConverter.ToDTO);
            return Ok(mealsDto);
        }

        [HttpGet("get/{id}")]
        public async Task<ActionResult<MealDTO>> GetMeal(int id)
        {
            var meal = await _service.GetMealByIdAsync(id);
            if (meal == null) return NotFound();
            var mealDto = MealConverter.ToDTO(meal);
            return Ok(mealDto);
        }

        [HttpGet("user/{userId}")]
        public async Task<IActionResult> GetMealsByUserId(int userId)
        {
            var meals = await _service.GetMealDTOsForUserAsync(userId);
            foreach (var meal in meals)
            {
                Console.WriteLine($"👉Controller MealID: {meal.Id}, Calories: {meal.Calories}, Date: {meal.Date}");
            }
            return Ok(meals);
        }

        [HttpPost("create")]
        public async Task<IActionResult> CreateMeal([FromBody] MealDTO mealDto, int userId)
        {
            var meal = MealConverter.ToModelFromDTO(mealDto, userId);
            var savedMeal = await _service.AddMealAsync(meal);

            var savedMealDto = new MealDTO
            {
                Id = savedMeal.Id,
                Name = savedMeal.Name,
                Description = savedMeal.Description,
                Calories = savedMeal.Calories
            };

            Console.WriteLine("Saved Meal ID: " + savedMeal.Id);

            return CreatedAtAction(nameof(GetMeal), new { id = savedMeal.Id }, savedMealDto);
        }

        [HttpPut("update/{id}")]
        public async Task<IActionResult> UpdateMeal(int id, [FromBody] MealDTO mealDto)
        {
            var existingMeal = await _service.GetMealByIdAsync(id);
            if (existingMeal == null) return NotFound();

            existingMeal.Name = mealDto.Name;
            existingMeal.Description = mealDto.Description;
            existingMeal.Calories = mealDto.Calories;

            await _service.UpdateMealAsync(existingMeal);
            return NoContent();
        }

        [HttpDelete("delete/{id}")]
        public async Task<IActionResult> DeleteMeal(int id)
        {
            await _service.DeleteMealAsync(id);
            return NoContent();
        }
    }
}