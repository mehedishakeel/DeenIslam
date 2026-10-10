package com.mehedishakeel.deenislam

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlin.math.abs

class MainActivity : FlutterActivity(), SensorEventListener {
    private val AUDIO_CHANNEL = "com.mehedishakeel.deenislam/audio"
    private val COMPASS_CHANNEL = "com.mehedishakeel.deenislam/compass"

    private var mediaPlayer: MediaPlayer? = null
    private var audioChannel: MethodChannel? = null
    private var compassChannel: MethodChannel? = null
    private val mainHandler = Handler(Looper.getMainLooper())

    private var sensorManager: SensorManager? = null
    private var accelerometer: Sensor? = null
    private var magnetometer: Sensor? = null
    private val gravity = FloatArray(3)
    private val geomagnetic = FloatArray(3)
    private var hasGravity = false
    private var hasGeomagnetic = false
    private var lastSentAzimuth = -1000f

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        sensorManager = getSystemService(Context.SENSOR_SERVICE) as? SensorManager
        accelerometer = sensorManager?.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
        magnetometer = sensorManager?.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD)

        audioChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, AUDIO_CHANNEL)
        audioChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "playUrl" -> {
                    val url = call.argument<String>("url")
                    if (url.isNullOrEmpty()) {
                        result.error("INVALID_URL", "Audio URL is empty", null)
                    } else {
                        playAudioUrl(url, result)
                    }
                }
                "pause" -> {
                    try {
                        if (mediaPlayer?.isPlaying == true) {
                            mediaPlayer?.pause()
                        }
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("PAUSE_ERR", e.message, null)
                    }
                }
                "resume" -> {
                    try {
                        mediaPlayer?.start()
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("RESUME_ERR", e.message, null)
                    }
                }
                "stop" -> {
                    releasePlayer()
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }

        compassChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, COMPASS_CHANNEL)
        compassChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "startCompass" -> {
                    val hasSensor = startCompassListening()
                    result.success(hasSensor)
                }
                "stopCompass" -> {
                    stopCompassListening()
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun startCompassListening(): Boolean {
        val sm = sensorManager ?: return false
        val accel = accelerometer
        val mag = magnetometer
        if (accel == null || mag == null) {
            return false
        }
        sm.registerListener(this, accel, SensorManager.SENSOR_DELAY_UI)
        sm.registerListener(this, mag, SensorManager.SENSOR_DELAY_UI)
        return true
    }

    private fun stopCompassListening() {
        sensorManager?.unregisterListener(this)
        hasGravity = false
        hasGeomagnetic = false
    }

    override fun onSensorChanged(event: SensorEvent?) {
        if (event == null) return
        val alpha = 0.88f
        if (event.sensor.type == Sensor.TYPE_ACCELEROMETER) {
            if (!hasGravity) {
                System.arraycopy(event.values, 0, gravity, 0, 3)
                hasGravity = true
            } else {
                gravity[0] = alpha * gravity[0] + (1 - alpha) * event.values[0]
                gravity[1] = alpha * gravity[1] + (1 - alpha) * event.values[1]
                gravity[2] = alpha * gravity[2] + (1 - alpha) * event.values[2]
            }
        } else if (event.sensor.type == Sensor.TYPE_MAGNETIC_FIELD) {
            if (!hasGeomagnetic) {
                System.arraycopy(event.values, 0, geomagnetic, 0, 3)
                hasGeomagnetic = true
            } else {
                geomagnetic[0] = alpha * geomagnetic[0] + (1 - alpha) * event.values[0]
                geomagnetic[1] = alpha * geomagnetic[1] + (1 - alpha) * event.values[1]
                geomagnetic[2] = alpha * geomagnetic[2] + (1 - alpha) * event.values[2]
            }
        }

        if (hasGravity && hasGeomagnetic) {
            val r = FloatArray(9)
            val i = FloatArray(9)
            if (SensorManager.getRotationMatrix(r, i, gravity, geomagnetic)) {
                val orientation = FloatArray(3)
                SensorManager.getOrientation(r, orientation)
                var azimuth = Math.toDegrees(orientation[0].toDouble()).toFloat()
                azimuth = (azimuth + 360f) % 360f
                if (abs(azimuth - lastSentAzimuth) >= 0.8f) {
                    lastSentAzimuth = azimuth
                    mainHandler.post {
                        compassChannel?.invokeMethod(
                            "onHeadingChanged",
                            mapOf("heading" to azimuth.toDouble())
                        )
                    }
                }
            }
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        // No-op
    }

    private fun playAudioUrl(url: String, result: MethodChannel.Result) {
        releasePlayer()
        try {
            val mp = MediaPlayer()
            mediaPlayer = mp
            mp.setAudioAttributes(
                AudioAttributes.Builder()
                    .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                    .setUsage(AudioAttributes.USAGE_MEDIA)
                    .build()
            )
            mp.setDataSource(url)
            mp.setOnPreparedListener { player ->
                player.start()
                mainHandler.post {
                    audioChannel?.invokeMethod(
                        "onPrepared",
                        mapOf("url" to url, "duration" to player.duration)
                    )
                }
            }
            mp.setOnCompletionListener {
                mainHandler.post {
                    audioChannel?.invokeMethod("onCompleted", mapOf("url" to url))
                }
            }
            mp.setOnErrorListener { _, what, extra ->
                mainHandler.post {
                    audioChannel?.invokeMethod(
                        "onError",
                        mapOf("what" to what, "extra" to extra)
                    )
                }
                true
            }
            mp.prepareAsync()
            result.success(true)
        } catch (e: Exception) {
            result.error("PLAY_ERR", e.message, null)
        }
    }

    private fun releasePlayer() {
        try {
            if (mediaPlayer?.isPlaying == true) {
                mediaPlayer?.stop()
            }
        } catch (_: Exception) {}
        try {
            mediaPlayer?.release()
        } catch (_: Exception) {}
        mediaPlayer = null
    }

    override fun onPause() {
        stopCompassListening()
        super.onPause()
    }

    override fun onDestroy() {
        stopCompassListening()
        releasePlayer()
        super.onDestroy()
    }
}
