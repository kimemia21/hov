
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotifyplayer/models/Device.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SpotifyDevicesStream extends StatelessWidget {
  final Stream<List<Device>> devicesStream;

  const SpotifyDevicesStream({Key? key, required this.devicesStream}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Device>>(
      stream: devicesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No devices available',
              style: TextStyle(color: Colors.green[700], fontSize: 16),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final device = snapshot.data![index];
              return _buildDeviceItem(device);
            },
          ),
        );
      },
    );
  }

  Widget _buildDeviceItem(Device device) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: device.isActive ? Colors.grey[900] : Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _getDeviceIcon(device.type),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  device.type,
                  style: TextStyle(
                    color: Colors.green[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          _buildVolumeIndicator(device),
        ],
      ),
    );
  }

  Widget _getDeviceIcon(String type) {
    switch (type) {
      case 'Smartphone':
        return Icon(FontAwesomeIcons.mobile, color: Colors.green[500]);
      case 'Computer':
        return Icon(FontAwesomeIcons.desktop, color: Colors.green[500]);
      default:
        return Icon(FontAwesomeIcons.music, color: Colors.green[500]);
    }
  }

  Widget _buildVolumeIndicator(Device device) {
    if (!device.supportsVolume) {
      return Text(
        'No Volume',
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      );
    }

    return Row(
      children: [
        Icon(
          device.volumePercent > 0 
            ? Icons.volume_up 
            : Icons.volume_off,
          color: device.volumePercent > 0 ? Colors.green : Colors.red,
          size: 20,
        ),
        const SizedBox(width: 4),
        Text(
          '${device.volumePercent}%',
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }
}
