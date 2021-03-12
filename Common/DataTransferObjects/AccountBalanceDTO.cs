using System;
using System.Collections.Generic;
using System.Text;

namespace Common.DataTransferObjects
{
    public class AccountBalanceDTO
    {
        public List<PaymentDTO> Payments { get; set; } = new List<PaymentDTO>();
        public decimal AccountBalance { get; set; }
        public string AccountStatus { get; set; }
        public string AccountName { get; set; }
        public int AccountId { get; set; }
    }
}
