using dotnet.DAL;
using dotnet.Models;

public static class CategoryConverter
{
    public static WorkoutCategory FromCategoryDAL(WorkoutCategoryDAL categoryDAL)
    {
        return new WorkoutCategory
        {
            Id = categoryDAL.CategoryID,
            Name = categoryDAL.Name,
            Icon = categoryDAL.Icon
        };
    }

    public static WorkoutCategoryDAL ToCategoryDAL(WorkoutCategory category)
    {
        return new WorkoutCategoryDAL
        {
            CategoryID = category.Id,
            Name = category.Name,
            Icon = category.Icon
        };
    }
    
    public static CategoryDTO ToCategoryDTO(WorkoutCategory category)
    {
        return new CategoryDTO
        {
            Id = category.Id,
            Name = category.Name
        };
    }

    public static WorkoutCategory FromCategoryDTO(CategoryDTO categoryDTO)
    {
        return new WorkoutCategory
        {
            Id = categoryDTO.Id, // Might be 0 for new categories
            Name = categoryDTO.Name
        };
    }
}
