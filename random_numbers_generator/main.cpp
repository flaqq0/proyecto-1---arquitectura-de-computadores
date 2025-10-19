#include <iostream>
#include <iomanip>
#include <random>
#include <cstdint>
#include <cstring>
#include <limits>
using namespace std;

uint16_t fp32_16(float value) {
    uint32_t bits;
    memcpy(&bits, &value, sizeof(bits));

    uint32_t sign = (bits >> 31) & 0x1;
    uint32_t exp  = (bits >> 23) & 0xFF;
    uint32_t mant = bits & 0x7FFFFF;

    uint16_t hsign = sign << 15;
    uint16_t hexp, hmant;

    if (exp == 255) { // Inf o NaN
        hexp = 0x1F << 10;
        hmant = (mant ? 0x200 : 0); // NaN si mantissa != 0
    } else if (exp > 112) { // número normal
        int newExp = exp - 112;
        if (newExp >= 31) {
            hexp = 0x1F << 10; // overflow -> inf
            hmant = 0;
        } else {
            hexp = (newExp & 0x1F) << 10;
            hmant = (mant >> 13) & 0x3FF;
        }
    } else if (exp >= 103) { // denormal
        int shift = 126 - exp;
        hmant = ((mant | 0x800000) >> (shift + 13)) & 0x3FF;
        hexp = 0;
    } else {
        hexp = 0; // underflow -> 0
        hmant = 0;
    }

    return hsign | hexp | hmant;
}

int main() {
    random_device rd;
    mt19937 gen(rd());
    uniform_real_distribution<float> dist(-1000.0f, 1000.0f);
    uniform_int_distribution<int> special(0, 9); // valores especiales

    int bits;
    cout << "16 o 32 bits: ";
    cin >> bits;

    cout << "\n=== 10 valores generados ===\n";

    for (int i = 0; i < 10; ++i) {
        float value;
        int type = special(gen);

        // 30% especiales, 70% números normales
        if (type == 0)
            value = numeric_limits<float>::infinity();
        else if (type == 1)
            value = -numeric_limits<float>::infinity();
        else if (type == 2)
            value = numeric_limits<float>::quiet_NaN();
        else
            value = dist(gen);

        if (bits == 16) {
            uint16_t b16 = fp32_16(value);
            cout << i << ". 0x" << hex << setw(4) << setfill('0') << b16 << dec << "\n";
        } else { // 32 bits
            uint32_t b32;
            memcpy(&b32, &value, sizeof(b32));
            cout << i << ".0x" << hex << setw(8) << setfill('0') << b32 << dec << "\n";
        }
    }

    return 0;
}
