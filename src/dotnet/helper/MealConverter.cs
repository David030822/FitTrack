using dotnet.DAL;
using dotnet.Models;
using dotnet.DTOs;

namespace dotnet.Converters
{
    public static class MealConverter
    {
        public static Meal ToModel(MealDAL dal)
        {
            return new Meal
            {
                Id = dal.MealID,
                UserId = dal.UserID,
                Name = dal.Name,
                Description = dal.Description,
                Calories = dal.Calories.Amount,
                CreatedAt = dal.Calories.DateTime
            };
        }

        public static MealDAL ToDAL(Meal model, int caloriesId)
        {
            return new MealDAL
            {
                MealID = model.Id,
                UserID = model.UserId,
                CaloriesID = caloriesId,
                Name = model.Name,
                Description = model.Description
            };
        }

        public static MealDTO ToDTO(Meal model)
        {
            return new MealDTO
            {
                Id = model.Id,
                Name = model.Name,
                Calories = model.Calories,
                Description = model.Description,
                Date = model.CreatedAt.ToLocalTime()
            };
        }

        public static Meal ToModelFromDTO(MealDTO dto, int userId)
        {
            return new Meal
            {
                Id = dto.Id,
                Name = dto.Name,
                UserId = userId,
                Description = dto.Description,
                Calories = dto.Calories,
                CreatedAt = dto.Date.ToUniversalTime()
            };
        }
    }
}