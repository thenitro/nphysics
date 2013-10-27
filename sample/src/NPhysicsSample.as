package {
	import com.thenitro.nphysics.sample.SampleAABBCircleImpulse;
	import com.thenitro.nphysics.sample.SampleAABBImpulse;
	import com.thenitro.nphysics.sample.SampleCircleImpulse;
	
	import ngine.display.DocumentClass;
	
	[SWF(frameRate="60", width="1000",height="800")]
	public class NPhysicsSample extends DocumentClass {
		
		public function NPhysicsSample() {
			//super(SampleAABBImpulse, true);
			//super(SampleCircleImpulse, true);
			super(SampleAABBCircleImpulse, true);
		};
	};
}