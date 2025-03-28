namespace dotnet.DTOs
{
    public class RegisterDTO
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string PhoneNum { get; set; }
        public string Username { get; set; }
        public string Password { get; set; } // Raw password from frontend
    }
}