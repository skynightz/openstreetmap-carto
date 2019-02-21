@water-text: #4d80b3;

#water-areas {
  [landuse = 'basin']::landuse {
    [zoom >= 7][way_pixels >= 32],
    [zoom >= 8] {
      [int_intermittent = 'no'] {
        polygon-fill: @water-color;
        [way_pixels >= 4] {
          polygon-gamma: 0.75;
        }
        [way_pixels >= 64] {
          polygon-gamma: 0.6;
        }
      }
      [int_intermittent = 'yes'] {
        polygon-pattern-file: url('symbols/intermittent_water.png');
        [way_pixels >= 4] {
          polygon-pattern-gamma: 0.75;
        }
        [way_pixels >= 64] {
          polygon-pattern-gamma: 0.6;
        }
      }
    }
  }

  [natural = 'water']::natural,
  [landuse = 'reservoir']::landuse, {
    [zoom >= 0][zoom < 1][way_pixels >= 4],
    [zoom >= 1][zoom < 2][way_pixels >= 16],
    [zoom >= 2][zoom < 8][way_pixels >= 32],
    [zoom >= 8] {
      [int_intermittent = 'no'] {
        polygon-fill: @water-color;
        [way_pixels >= 4] {
          polygon-gamma: 0.75;
        }
        [way_pixels >= 64] {
          polygon-gamma: 0.6;
        }
      }
      [int_intermittent = 'yes'] {
        polygon-pattern-file: url('symbols/intermittent_water.png');
        [way_pixels >= 4] {
          polygon-pattern-gamma: 0.75;
        }
        [way_pixels >= 64] {
          polygon-pattern-gamma: 0.6;
        }
      }
    }
  }
}

.text-low-zoom[zoom < 10],
.text[zoom >= 10] {
  [feature = 'natural_water'],
  [feature = 'natural_bay'],
  [feature = 'natural_strait'],
  [feature = 'landuse_reservoir'],
  [feature = 'landuse_basin'] {
    [zoom >= 0][way_pixels > 3000],
    [zoom >= 17] {
      text-name: "[name]";
      text-size: 10;
      text-wrap-width: 25; // 2.5 em
      text-line-spacing: -1.5; // -0.15 em
      [way_pixels > 12000] {
        text-size: 12;
        text-wrap-width: 37; // 3.1 em
        text-line-spacing: -1.6; // -0.13 em
      }
      [way_pixels > 48000] {
        text-size: 15;
        text-wrap-width: 59; // 3.9 em
        text-line-spacing: -1.5; // -0.10 em
      }
      [way_pixels > 192000] {
        text-size: 19;
        text-wrap-width: 95; // 5.0 em
        text-line-spacing: -0.95; // -0.05 em
      }
      text-fill: @water-text;
      text-face-name: @oblique-fonts;
      text-halo-radius: @standard-halo-radius;
      text-halo-fill: @standard-halo-fill;
      text-placement: interior;
    }
  }
}
