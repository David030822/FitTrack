using dotnet.DAL;
using dotnet.DTOs;
using dotnet.Models;

namespace dotnet.Helper
{
    public static class WorkoutConverter
    {
        public static WorkoutDAL FromWorkoutToWorkoutDAL(Workout workout)
        {
            return new WorkoutDAL
            {
                WorkoutID = workout.Id,
                UserID = workout.UserId,
                CategoryID = workout.CategoryId,
                Distance = workout.Distance,
                StartDate = DateTime.SpecifyKind(workout.StartDate, DateTimeKind.Utc),
                EndDate = workout.EndDate.HasValue 
                    ? DateTime.SpecifyKind(workout.EndDate.Value, DateTimeKind.Utc)
                    : null
            };
        }

        public static Workout FromWorkoutDALToWorkout(WorkoutDAL workoutDAL)
        {
            return new Workout
            {
                Id = workoutDAL.WorkoutID,
                UserId = workoutDAL.UserID,
                CategoryId = workoutDAL.CategoryID,
                Distance = workoutDAL.Distance,
                StartDate = DateTime.SpecifyKind(workoutDAL.StartDate, DateTimeKind.Utc),
                EndDate = workoutDAL.EndDate.HasValue 
                    ? DateTime.SpecifyKind(workoutDAL.EndDate.Value, DateTimeKind.Utc) 
                    : null
            };
        }

        public static WorkoutDTO FromWorkoutToWorkoutDTO(Workout workout)
        {
            return new WorkoutDTO
            {
                Id = workout.Id,
                Distance = workout.Distance,
                StartDate = workout.StartDate,
                EndDate = workout.EndDate,                     // 🆕 or calculate here
            };
        }

        public static Workout FromWorkoutDTOToWorkout(WorkoutDTO workoutDTO, int userId, int categoryId)
        {
            return new Workout
            {
                Id = workoutDTO.Id,
                UserId = userId,
                CategoryId = categoryId,
                Distance = workoutDTO.Distance ?? 0.0,
                StartDate = workoutDTO.StartDate ?? DateTime.UtcNow,
                EndDate = workoutDTO.EndDate
            };
        }
    }
}
