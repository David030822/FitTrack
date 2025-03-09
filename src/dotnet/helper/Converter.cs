using dotnet.DAL;
using dotnet.DTOs;
using dotnet.Models;

namespace dotnet.Helper
{
    public static class UserConverter
    {
        // Convert from User to UserDAL (Database Model)
        public static UserDAL FromUserToUserDAL(User user)
        {
            return new UserDAL
            {
                UserID = user.Id,  // Assuming `Id` is the primary key in `User`
                UDID = user.Udid,
                FirstName = user.FirstName,
                LastName = user.LastName,
                Email = user.Email,
                Password = user.Password,  // Hashing should be handled separately
                ProfilePhotoPath = user.ProfilePhotoPath
            };
        }

        // Convert from UserDAL (Database Model) to User
        public static User FromUserDALToUser(UserDAL userDAL)
        {
            return new User
            {
                Id = userDAL.UserID,
                Udid = userDAL.UDID,
                FirstName = userDAL.FirstName,
                LastName = userDAL.LastName,
                Email = userDAL.Email,
                Password = userDAL.Password,
                ProfilePhotoPath = userDAL.ProfilePhotoPath
            };
        }

        // Convert from User to UserDTO (Frontend Model)
        public static UserDTO FromUserToUserDTO(User user)
        {
            return new UserDTO
            {
                FirstName = user.FirstName,
                LastName = user.LastName,
                Email = user.Email,
                Password = user.Password,
                ProfilePhotoPath = user.ProfilePhotoPath
            };
        }

        // Convert from UserDTO (Frontend Model) to User
        public static User FromUserDTOToUser(UserDTO userDTO, int id = 0, int udid = 0)
        {
            return new User
            {
                Id = id, // Set only if provided
                Udid = udid, // Set only if provided
                FirstName = userDTO.FirstName,
                LastName = userDTO.LastName,
                Email = userDTO.Email,
                Password = userDTO.Password,
                ProfilePhotoPath = userDTO.ProfilePhotoPath
            };
        }
    }
}
