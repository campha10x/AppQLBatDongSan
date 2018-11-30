using System;
namespace BatDongSanAPI.Models
{
    public class CanHo
    {
        private BatDongSanStoreContext context;

        public string IdCanHo { get; set; }

        public string TenCanHo { get; set; }

        public string DonGia { get; set; }

        public string SoDienCu { get; set; }

        public string SoNuocCu { get; set; }

        public string DienTich { get; set; }

        public string DiaChi { get; set; }
    }
}
