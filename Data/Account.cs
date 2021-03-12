using System;
using System.Collections.Generic;

// Code scaffolded by EF Core assumes nullable reference types (NRTs) are not used or disabled.
// If you have enabled NRTs for your project, then un-comment the following line:
// #nullable disable

namespace Data
{
    public partial class Account
    {
        public Account()
        {
            Payment = new HashSet<Payment>();
        }

        public int Id { get; set; }
        public string AccountName { get; set; }
        public int Status { get; set; }
        public string Comment { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime LastModifiedDateTime { get; set; }

        public virtual ICollection<Payment> Payment { get; set; }
    }
}
