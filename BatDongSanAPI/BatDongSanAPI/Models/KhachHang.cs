using System;
namespace BatDongSanAPI.Models
{
    public class KhachHang
    {
        private BatDongSanStoreContext context;

        public String IdKhachHang { get; set; }
        public String TenKH { get; set; }
        public String IdCanHo { get; set; }
        public String NgaySinh { get; set; }
        public String GioiTinh { get; set; }
        public String SDT { get; set; }
        public String Email { get; set; }
        public String CMND { get; set; }
        public String Quequan { get; set; }
        public String NgayCap { get; set; }
        public String NoiCap { get; set; }
        public KhachHang()
        {
        }
    }
}
