// MealService.cs
using dotnet.Converters;
using dotnet.DAL;
using dotnet.DTOs;
using dotnet.Models;
using dotnet.Repositories;

namespace dotnet.Services
{
    public class MealService : IMealService
    {
        private readonly IMealRepository _repository;

        public MealService(IMealRepository repository)
        {
            _repository = repository;
        }

        public async Task<List<Meal>> GetAllMealsAsync()
        {
            var meals = await _repository.GetAllMealsAsync();
            return meals.Select(mealDal =>
            {
                var model = MealConverter.ToModel(mealDal);
                return model;
            }).ToList();
        }

        public async Task<Meal?> GetMealByIdAsync(int id)
        {
            var dal = await _repository.GetMealByIdAsync(id);
            if (dal == null) return null;

            var model = MealConverter.ToModel(dal);
            return model;
        }

        public async Task<Meal> AddMealAsync(Meal meal)
        {   
            return await _repository.AddMealAsync(meal);
        }

        public async Task UpdateMealAsync(Meal meal)
        {
            await _repository.UpdateMealAsync(meal);
        }

        public async Task DeleteMealAsync(int id)
        {
            await _repository.DeleteMealAsync(id);
        }

        public async Task<IEnumerable<MealDTO>> GetMealDTOsForUserAsync(int userId)
        {
            return await _repository.GetMealDTOsForUserAsync(userId);
        }
    }
}
