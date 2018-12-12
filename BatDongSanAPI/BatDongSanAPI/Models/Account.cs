using System;
using MySql.Data.MySqlClient;
using System.Collections.Generic;

namespace BatDongSanAPI.Models
{
    public class Account
    {
        private BatDongSanStoreContext context;

        public string IdAccount { get; set; }

        public string Email { get; set; }

        public string MatKhau { get; set; }

        public string HoTen { get; set; }

        public string Gioitinh { get; set; }

        public string NamSinh { get; set; }

        public string SDT { get; set; }

        public string DiaChi { get; set; }

        public string CMND { get; set; }

        public string NgayCap { get; set; }

        public string NoiCap { get; set; }

    }
    
}
