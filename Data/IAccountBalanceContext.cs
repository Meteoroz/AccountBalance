using Microsoft.EntityFrameworkCore;

namespace Data
{
    public interface IAccountBalanceContext
    {
        DbSet<Account> Account { get; set; }
        DbSet<Payment> Payment { get; set; }
        DbSet<Status> Status { get; set; }
    }
}