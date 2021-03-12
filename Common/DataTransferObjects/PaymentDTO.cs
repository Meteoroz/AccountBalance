using System;
using System.Collections.Generic;
using System.Text;

namespace Common.DataTransferObjects
{
    public class PaymentDTO
    {
        public decimal Amount { get; set; }
        public DateTime CreatedDateTime { get; set; }
    }
}
