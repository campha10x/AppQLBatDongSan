using System;
using MySql.Data.MySqlClient;
using System.Collections.Generic;

namespace BatDongSanAPI.Models
{
    public class Account
    {
        private BatDongSanStoreContext context;

        public int IdNhaTro { get; set; }

        public string Email { get; set; }

        public string MatKhau { get; set; }

        public string Hoten { get; set; }

        public bool Gioitinh { get; set; }

        public int NamSinh { get; set; }

        public string Sdt { get; set; }

        public string DiaChi { get; set; }

        public string AnhDaiDien { get; set; }

    }
    
}
