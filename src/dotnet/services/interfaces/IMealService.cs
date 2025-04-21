using dotnet.DTOs;
using dotnet.Models;

namespace dotnet.Services
{
    public interface IMealService
    {
        Task<List<Meal>> GetAllMealsAsync();
        Task<Meal?> GetMealByIdAsync(int id);
        Task<Meal> AddMealAsync(Meal meal);
        Task UpdateMealAsync(Meal meal);
        Task DeleteMealAsync(int id);
        Task<IEnumerable<MealDTO>> GetMealDTOsForUserAsync(int userId);
    }
}