#!/system/bin/sh

# 1. Hàm sinh ngẫu nhiên số IMEI hợp lệ (Luhn Algorithm)
imei=""
for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14; do
    imei="${imei}$((RANDOM % 10))"
done
sum=0
for i in 0 1 2 3 4 5 6 7 8 9 10 11 12 13; do
    d=$(echo $imei | cut -b $((i+1)))
    if [ $((i % 2)) -eq 1 ]; then
        d=$((d * 2))
        if [ $d -gt 9 ]; then d=$((d - 9)); fi
    fi
    sum=$((sum + d))
done
last=$(((10 - (sum % 10)) % 10))
FINAL_IMEI="${imei}${last}"

# 2. Ghi đè IMEI vào hệ thống Android
setprop ro.ril.oem.imei "$FINAL_IMEI"
setprop ro.product.imei "$FINAL_IMEI"

# 3. Giả lập luôn trạng thái PIN 100% khi khởi động
dumpsys battery set ac 1
dumpsys battery set usb 1
dumpsys battery set level 100
dumpsys battery set status 2
dumpsys battery unplug
